import axios from "axios";
import { createInertiaApp } from "@inertiajs/react";
import { createRoot, hydrateRoot } from "react-dom/client";
import { resolvePageWithLayout } from "./layout-mapping";
axios.defaults.xsrfHeaderName = "x-csrf-token";

createInertiaApp({
  resolve: async (name) => resolvePageWithLayout(name),
  setup({ App, el, props }) {
    if (process.env.NODE_ENV === "production" && props.initialPage.props.ssr) {
      hydrateRoot(el, <App {...props} />);
    } else {
      createRoot(el).render(<App {...props} />);
    }
  },
});
