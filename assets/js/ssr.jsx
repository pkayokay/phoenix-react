import { createInertiaApp } from "@inertiajs/react";
import ReactDOMServer from "react-dom/server";

import { resolvePageWithLayout } from "./layout-mapping";

export function render(page) {
  return createInertiaApp({
    page,
    render: ReactDOMServer.renderToString,
    resolve: async (name) => resolvePageWithLayout(name),
    setup: ({ App, props }) => <App {...props} />,
  });
}
