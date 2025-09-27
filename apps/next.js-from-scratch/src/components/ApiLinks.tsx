'use client';

import { useState } from 'react';

export default function ApiLinks() {
  const [routeHandlerResponse, setRouteHandlerResponse] = useState<string>('');
  const [apiRouteResponse, setApiRouteResponse] = useState<string>('');

  const callRouteHandler = async () => {
    try {
      const response = await fetch('/api/hello');
      const text = await response.text();
      setRouteHandlerResponse(text);
    } catch (error) {
      setRouteHandlerResponse(`Error: ${error}`);
    }
  };

  const callApiRoute = async () => {
    try {
      const response = await fetch('/api/hello-pages');
      const data = await response.json();
      setApiRouteResponse(JSON.stringify(data, null, 2));
    } catch (error) {
      setApiRouteResponse(`Error: ${error}`);
    }
  };

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Next.js API Links Demo</h1>
      
      <div className="space-y-6">
        <div className="border p-4 rounded-lg">
          <h2 className="text-xl font-semibold mb-3">App Router - Route Handler</h2>
          <p className="text-gray-600 mb-3">
            Route Handler located at: <code className="bg-gray-100 px-2 py-1 rounded">app/api/hello/route.ts</code>
          </p>
          <button 
            onClick={callRouteHandler}
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mr-3"
          >
            Call Route Handler
          </button>
          <a 
            href="/api/hello" 
            target="_blank" 
            rel="noopener noreferrer"
            className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded inline-block"
          >
            Open Link in New Tab
          </a>
          {routeHandlerResponse && (
            <div className="mt-3 p-3 bg-gray-100 rounded">
              <strong>Response:</strong> {routeHandlerResponse}
            </div>
          )}
        </div>

        <div className="border p-4 rounded-lg">
          <h2 className="text-xl font-semibold mb-3">Pages Router - API Route</h2>
          <p className="text-gray-600 mb-3">
            API Route located at: <code className="bg-gray-100 px-2 py-1 rounded">pages/api/hello-pages.ts</code>
          </p>
          <button 
            onClick={callApiRoute}
            className="bg-purple-500 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded mr-3"
          >
            Call API Route
          </button>
          <a 
            href="/api/hello-pages" 
            target="_blank" 
            rel="noopener noreferrer"
            className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded inline-block"
          >
            Open Link in New Tab
          </a>
          {apiRouteResponse && (
            <div className="mt-3 p-3 bg-gray-100 rounded">
              <strong>Response:</strong> 
              <pre className="mt-2 text-sm">{apiRouteResponse}</pre>
            </div>
          )}
        </div>

        <div className="border p-4 rounded-lg bg-yellow-50">
          <h3 className="text-lg font-semibold mb-2">How Links Work</h3>
          <ul className="list-disc pl-5 space-y-1 text-sm">
            <li><strong>Direct Links:</strong> Use anchor tags with href=&quot;/api/hello&quot; to directly navigate to API endpoints</li>
            <li><strong>Fetch Calls:</strong> Use fetch() to programmatically call API routes and handle responses</li>
            <li><strong>Next.js Link:</strong> Use Next.js Link component for client-side navigation between pages</li>
            <li><strong>Different Routes:</strong> App Router uses /api/hello, Pages Router uses /api/hello-pages (to avoid conflicts)</li>
          </ul>
        </div>
      </div>
    </div>
  );
}