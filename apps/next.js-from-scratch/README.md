# Next.js API Routes and Links Implementation

This project demonstrates how to create and link to Next.js API routes using both the App Router and Pages Router approaches.

## API Routes Implemented

### 1. App Router - Route Handler
**File:** `app/api/hello/route.ts`
```typescript
export async function GET(request: Request) {
  return new Response('Hello from Route Handler!');
}
```

### 2. Pages Router - API Route
**File:** `pages/api/hello.ts`
```typescript
import type { NextApiRequest, NextApiResponse } from 'next';

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  res.status(200).json({ message: 'Hello from API Route!' });
}
```

## Creating Links to API Routes

### 1. Direct HTML Links
Use standard anchor tags to create direct links to your API endpoints:

```html
<a href="/api/hello" target="_blank">Open API Route</a>
```

### 2. Programmatic Fetch Calls
Use JavaScript fetch to call API routes and handle responses:

```javascript
const response = await fetch('/api/hello');
const data = await response.json();
```

### 3. Next.js Link Component
For client-side navigation between pages (not typically used for API routes):

```jsx
import Link from 'next/link';

<Link href="/about">About Page</Link>
```

## Running the Application

1. Install dependencies:
```bash
npm install
```

2. Run the development server:
```bash
npm run dev
```

3. Open [http://localhost:3000](http://localhost:3000) to see the demo.

## API Route URLs

Both implementations will be available at:
- `GET /api/hello` - Accessible via browser or fetch calls

## Key Differences

- **Route Handlers (App Router):** Return Web API Response objects
- **API Routes (Pages Router):** Use Next.js specific req/res objects
- **Both:** Share the same URL pattern and can coexist in the same project

## Files Structure

```
app/
├── api/
│   └── hello/
│       └── route.ts          # App Router API endpoint
├── layout.tsx                # Root layout
└── page.tsx                  # Main page

pages/
└── api/
    └── hello.ts              # Pages Router API endpoint

src/
└── components/
    └── ApiLinks.tsx          # Demo component with link examples
```