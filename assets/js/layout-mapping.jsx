import React from "react";

export const resolvePageWithLayout = async (name) => {
  const page = await import(`./pages/${name}.tsx`);

  const layoutMap = {
    "admin/": "admin-layout",
    "auth/": "auth-layout",
    "marketing/": "marketing-layout",
    "sessions/": "auth-layout",
  };

  // Find matching layout key (e.g. "admin/")
  const layoutKey = Object.keys(layoutMap).find((prefix) => name.startsWith(prefix));

  if (layoutKey) {
    const layoutModule = await import(`./layouts/${layoutMap[layoutKey]}.tsx`);
    const Layout = layoutModule.default;
    page.default.layout ||= (component) => React.createElement(Layout, null, component);
  }
  return page;
};
