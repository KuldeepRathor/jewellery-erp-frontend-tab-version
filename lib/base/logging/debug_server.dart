import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:jewellery_erp_frontend_tab_version/base/logging/models/http_request_log.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:get/get.dart' hide Response;
import 'package:jewellery_erp_frontend_tab_version/base/logging/talker_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DebugServer {
  HttpServer? _server;
  static const int _port = 8765;
  Timer? _refreshTimer;

  Future<void> start() async {
    if (_server != null) {
      // Server already running, just open browser
      await _openBrowser();
      return;
    }

    final router = Router();

    // Main debug page
    router.get('/', _handleRoot);

    // API endpoint for logs
    router.get('/api/logs', _handleLogsApi);

    // Static assets (if needed)
    router.get('/api/clear', _handleClear);

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_corsHeaders())
        .addHandler(router.call);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, _port);
      log('Debug server running on http://localhost:$_port');

      await _openBrowser();
    } catch (e) {
      log('Failed to start debug server: $e');
    }
  }

  Future<void> stop() async {
    _refreshTimer?.cancel();
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _openBrowser() async {
    final url = Uri.parse('http://localhost:$_port');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Response _handleRoot(Request request) {
    final html = _generateHtml();
    return Response.ok(html, headers: {'Content-Type': 'text/html'});
  }

  Response _handleLogsApi(Request request) {
    final talkerController = Get.find<TalkerController>();
    final logs = talkerController.talker.history.toList().reversed.toList();

    final logsJson =
        logs.map((log) {
          if (log is HttpRequestLog) {
            return {...log.toJson(), 'timestamp': log.time.toIso8601String()};
          } else if (log is HttpResponseLog) {
            return {...log.toJson(), 'timestamp': log.time.toIso8601String()};
          } else if (log is HttpErrorLog) {
            return {...log.toJson(), 'timestamp': log.time.toIso8601String()};
          } else {
            return {
              'type': 'log',
              'level': log.logLevel.toString(),
              'message': log.message,
              'timestamp': log.time.toIso8601String(),
            };
          }
        }).toList();

    return Response.ok(
      jsonEncode(logsJson),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Response _handleClear(Request request) {
    final talkerController = Get.find<TalkerController>();
    talkerController.talker.cleanHistory();
    return Response.ok(jsonEncode({'success': true}));
  }

  Middleware _corsHeaders() {
    return (Handler handler) {
      return (Request request) async {
        final response = await handler(request);
        return response.change(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE',
            'Access-Control-Allow-Headers': 'Content-Type',
          },
        );
      };
    };
  }

  String _generateHtml() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Debug Logs - Zivoro</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: #1e1e1e;
            color: #d4d4d4;
        }

        .header {
            background: #2d2d30;
            padding: 16px 24px;
            border-bottom: 1px solid #3e3e42;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header h1 {
            font-size: 20px;
            font-weight: 500;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            background: #0e639c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s;
        }

        .btn:hover {
            background: #1177bb;
        }

        .btn-danger {
            background: #c72e0f;
        }

        .btn-danger:hover {
            background: #e03e12;
        }

        .search-bar {
            background: #2d2d30;
            padding: 12px 24px;
            border-bottom: 1px solid #3e3e42;
        }

        .search-input {
            width: 100%;
            background: #3c3c3c;
            border: 1px solid #555;
            color: #d4d4d4;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-input:focus {
            outline: none;
            border-color: #0e639c;
        }

        .logs-container {
            padding: 16px 24px;
        }

        .log-item {
            background: #2d2d30;
            border: 1px solid #3e3e42;
            border-radius: 4px;
            margin-bottom: 8px;
            overflow: hidden;
        }

        .log-header {
            padding: 12px 16px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: background 0.2s;
        }

        .log-header:hover {
            background: #37373d;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            min-width: 45px;
            text-align: center;
        }

        .method-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            background: #555;
        }

        .status-success {
            background: #16825d;
            color: white;
        }

        .status-error {
            background: #c72e0f;
            color: white;
        }

        .status-warning {
            background: #c27c0e;
            color: white;
        }

        .log-url {
            flex: 1;
            font-size: 14px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .log-meta {
            display: flex;
            gap: 16px;
            font-size: 12px;
            color: #858585;
        }

        .log-details {
            display: none;
            padding: 16px;
            background: #1e1e1e;
            border-top: 1px solid #3e3e42;
        }

        .log-details.expanded {
            display: block;
        }

        .detail-section {
            margin-bottom: 16px;
        }

        .detail-section:last-child {
            margin-bottom: 0;
        }

        .detail-title {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .copy-btn {
            background: #555;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 11px;
        }

        .copy-btn:hover {
            background: #666;
        }

        .detail-content {
            background: #252526;
            border: 1px solid #3e3e42;
            border-radius: 4px;
            padding: 12px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            overflow-x: auto;
            color: #9cdcfe;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .expand-icon {
            transition: transform 0.2s;
        }

        .expand-icon.expanded {
            transform: rotate(180deg);
        }

        .no-logs {
            text-align: center;
            padding: 64px 24px;
            color: #858585;
        }

        .timestamp {
            font-size: 11px;
            color: #858585;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🐛 Debug Logs - Zivoro</h1>
        <div class="header-actions">
            <button class="btn" onclick="exportLogs()">📥 Export</button>
            <button class="btn btn-danger" onclick="clearLogs()">🗑️ Clear All</button>
        </div>
    </div>

    <div class="search-bar">
        <input type="text" class="search-input" placeholder="Search logs..." id="searchInput" oninput="filterLogs()">
    </div>

    <div class="logs-container" id="logsContainer">
        <div class="no-logs">Loading logs...</div>
    </div>

    <script>
        let allLogs = [];
        let expandedIndices = new Set();

        async function fetchLogs() {
            try {
                console.log('Fetching logs from /api/logs...');
                const response = await fetch('/api/logs');
                console.log('Response status:', response.status);

                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                }

                const text = await response.text();
                console.log('Response text length:', text.length);

                allLogs = JSON.parse(text);
                console.log('Parsed logs count:', allLogs.length);

                renderLogs(allLogs);
            } catch (error) {
                console.error('Failed to fetch logs:', error);
                document.getElementById('logsContainer').innerHTML =
                    '<div class="no-logs">Error loading logs: ' + error.message + '<br><br>Check browser console for details.</div>';
            }
        }

        function renderLogs(logs) {
            const container = document.getElementById('logsContainer');

            if (logs.length === 0) {
                container.innerHTML = '<div class="no-logs">No logs yet. Start using your app to see network requests here.</div>';
                return;
            }

            const htmlParts = [];

            for (let index = 0; index < logs.length; index++) {
                const log = logs[index];

                if (log.type === 'request') {
                    htmlParts.push(renderRequest(log, index));
                } else if (log.type === 'response') {
                    htmlParts.push(renderResponse(log, index));
                } else if (log.type === 'error') {
                    htmlParts.push(renderError(log, index));
                } else {
                    htmlParts.push(renderGenericLog(log, index));
                }
            }

            container.innerHTML = htmlParts.join('');

            // Restore expanded state after render
            expandedIndices.forEach(function(index) {
                const details = document.getElementById('details-' + index);
                const icon = document.getElementById('icon-' + index);
                if (details && icon) {
                    details.classList.add('expanded');
                    icon.classList.add('expanded');
                }
            });
        }

        function renderRequest(log, index) {
            const isExpanded = expandedIndices.has(index);
            const html = '<div class="log-item">' +
                '<div class="log-header" onclick="toggleDetails(' + index + ')">' +
                '<span class="method-badge">' + escapeHtml(log.method) + '</span>' +
                '<span class="log-url">' + escapeHtml(log.url) + '</span>' +
                '<span class="log-meta">' +
                '<span>📤 Request</span>' +
                '<span class="timestamp">' + formatTime(log.timestamp) + '</span>' +
                '</span>' +
                '<span class="expand-icon ' + (isExpanded ? 'expanded' : '') + '" id="icon-' + index + '">▼</span>' +
                '</div>' +
                '<div class="log-details ' + (isExpanded ? 'expanded' : '') + '" id="details-' + index + '">' +
                (log.curlCommand ? renderCurl('cURL Command', log.curlCommand) : '') +
                renderHeaders('Request Headers', log.headers) +
                (log.body ? renderBody('Request Body', log.body) : '') +
                '</div>' +
                '</div>';
            return html;
        }

        function renderCurl(title, curlCommand) {
            if (!curlCommand) return '';

            const html = '<div class="detail-section">' +
                '<div class="detail-title">' +
                '<span>🔧 ' + title + '</span>' +
                '<button class="copy-btn" onclick="event.stopPropagation(); copyText(\\'' + escapeForAttr(curlCommand) + '\\')">Copy cURL</button>' +
                '</div>' +
                '<div class="detail-content">' + escapeHtml(curlCommand) + '</div>' +
                '</div>';
            return html;
        }

        function renderResponse(log, index) {
            const isExpanded = expandedIndices.has(index);
            const statusClass = log.statusCode >= 200 && log.statusCode < 300 ? 'status-success' :
                               log.statusCode >= 400 && log.statusCode < 500 ? 'status-warning' :
                               'status-error';
            const icon = log.statusCode >= 200 && log.statusCode < 300 ? '✅' : '❌';

            const html = '<div class="log-item">' +
                '<div class="log-header" onclick="toggleDetails(' + index + ')">' +
                '<span class="status-badge ' + statusClass + '">' + log.statusCode + '</span>' +
                '<span class="method-badge">' + escapeHtml(log.method) + '</span>' +
                '<span class="log-url">' + escapeHtml(log.url) + '</span>' +
                '<span class="log-meta">' +
                '<span>' + icon + ' Response</span>' +
                (log.duration ? '<span>⏱️ ' + log.duration + 'ms</span>' : '') +
                '<span class="timestamp">' + formatTime(log.timestamp) + '</span>' +
                '</span>' +
                '<span class="expand-icon ' + (isExpanded ? 'expanded' : '') + '" id="icon-' + index + '">▼</span>' +
                '</div>' +
                '<div class="log-details ' + (isExpanded ? 'expanded' : '') + '" id="details-' + index + '">' +
                renderHeaders('Response Headers', log.headers) +
                (log.body ? renderBody('Response Body', log.body) : '') +
                '</div>' +
                '</div>';
            return html;
        }

        function renderError(log, index) {
            const isExpanded = expandedIndices.has(index);
            const html = '<div class="log-item">' +
                '<div class="log-header" onclick="toggleDetails(' + index + ')">' +
                '<span class="status-badge status-error">' + (log.statusCode || 'ERR') + '</span>' +
                '<span class="method-badge">' + escapeHtml(log.method) + '</span>' +
                '<span class="log-url">' + escapeHtml(log.url) + '</span>' +
                '<span class="log-meta">' +
                '<span>⛔ ' + escapeHtml(log.errorMessage) + '</span>' +
                '<span class="timestamp">' + formatTime(log.timestamp) + '</span>' +
                '</span>' +
                '<span class="expand-icon ' + (isExpanded ? 'expanded' : '') + '" id="icon-' + index + '">▼</span>' +
                '</div>' +
                '<div class="log-details ' + (isExpanded ? 'expanded' : '') + '" id="details-' + index + '">' +
                '<div class="detail-section">' +
                '<div class="detail-content">Error Type: ' + escapeHtml(log.errorType) + '</div>' +
                '</div>' +
                (log.responseBody ? renderBody('Error Response', log.responseBody) : '') +
                '</div>' +
                '</div>';
            return html;
        }

        function renderGenericLog(log, index) {
            const html = '<div class="log-item">' +
                '<div class="log-header">' +
                '<span class="log-url">' + escapeHtml(log.message || 'Unknown') + '</span>' +
                '<span class="log-meta">' +
                '<span>' + escapeHtml(log.level || 'INFO') + '</span>' +
                '<span class="timestamp">' + formatTime(log.timestamp) + '</span>' +
                '</span>' +
                '</div>' +
                '</div>';
            return html;
        }

        function renderHeaders(title, headers) {
            if (!headers || Object.keys(headers).length === 0) {
                return '<div class="detail-section">' +
                    '<div class="detail-title"><span>' + title + '</span></div>' +
                    '<div class="detail-content">(empty)</div>' +
                    '</div>';
            }

            const jsonStr = JSON.stringify(headers, null, 2);
            const html = '<div class="detail-section">' +
                '<div class="detail-title">' +
                '<span>' + title + '</span>' +
                '<button class="copy-btn" onclick="event.stopPropagation(); copyText(\\'' + escapeForAttr(jsonStr) + '\\')">Copy</button>' +
                '</div>' +
                '<div class="detail-content">' + escapeHtml(jsonStr) + '</div>' +
                '</div>';
            return html;
        }

        function renderBody(title, body) {
            if (!body) {
                return '';
            }

            const formatted = typeof body === 'string' ? body : JSON.stringify(body, null, 2);
            const html = '<div class="detail-section">' +
                '<div class="detail-title">' +
                '<span>' + title + '</span>' +
                '<button class="copy-btn" onclick="event.stopPropagation(); copyText(\\'' + escapeForAttr(formatted) + '\\')">Copy</button>' +
                '</div>' +
                '<div class="detail-content">' + escapeHtml(formatted) + '</div>' +
                '</div>';
            return html;
        }

        function toggleDetails(index) {
            const details = document.getElementById('details-' + index);
            const icon = document.getElementById('icon-' + index);

            if (!details || !icon) {
                console.error('Elements not found for index:', index);
                return;
            }

            if (expandedIndices.has(index)) {
                expandedIndices.delete(index);
                details.classList.remove('expanded');
                icon.classList.remove('expanded');
            } else {
                expandedIndices.add(index);
                details.classList.add('expanded');
                icon.classList.add('expanded');
            }
        }

        function formatTime(timestamp) {
            try {
                const date = new Date(timestamp);
                return date.toLocaleTimeString();
            } catch (e) {
                return timestamp || '';
            }
        }

        function escapeHtml(text) {
            if (!text && text !== 0) return '';
            const div = document.createElement('div');
            div.textContent = String(text);
            return div.innerHTML;
        }

        function escapeForAttr(text) {
            if (!text && text !== 0) return '';
            return String(text)
                .replace(/\\\\/g, '\\\\\\\\')
                .replace(/'/g, "\\\\'")
                .replace(/\\n/g, '\\\\n')
                .replace(/\\r/g, '\\\\r');
        }

        function copyText(text) {
            navigator.clipboard.writeText(text).then(function() {
                alert('Copied to clipboard!');
            }).catch(function(err) {
                console.error('Failed to copy:', err);
                alert('Failed to copy to clipboard');
            });
        }

        function filterLogs() {
            const query = document.getElementById('searchInput').value.toLowerCase();
            const filtered = allLogs.filter(function(log) {
                const searchText = (log.url || log.message || '').toLowerCase();
                return searchText.includes(query);
            });
            renderLogs(filtered);
        }

        async function clearLogs() {
            if (confirm('Are you sure you want to clear all logs?')) {
                try {
                    await fetch('/api/clear');
                    expandedIndices.clear();
                    fetchLogs();
                } catch (err) {
                    console.error('Failed to clear logs:', err);
                    alert('Failed to clear logs');
                }
            }
        }

        function exportLogs() {
            const dataStr = JSON.stringify(allLogs, null, 2);
            const dataBlob = new Blob([dataStr], {type: 'application/json'});
            const url = URL.createObjectURL(dataBlob);
            const link = document.createElement('a');
            link.href = url;
            link.download = 'logs_' + new Date().toISOString().replace(/:/g, '-') + '.json';
            link.click();
            URL.revokeObjectURL(url);
        }

        // Auto-refresh every 2 seconds
        setInterval(fetchLogs, 2000);

        // Initial load
        fetchLogs();
    </script>
</body>
</html>
''';
  }
}
