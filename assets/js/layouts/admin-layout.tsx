import { Head, Link, usePage } from "@inertiajs/react";

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ flash: { error?: string; info?: string }; pageTitle: string }>();

  if (page.props.flash.info || page.props.flash.error) {
    alert(page.props.flash.info || page.props.flash.error);
  }
  return (
    <div className="p-7">
      <Head>
        <title>{page.props.pageTitle}</title>
      </Head>
      <Link href="/app/log_out" method="delete">
        Log Out
      </Link>
      <div className="mb-4 space-x-4">
        <Link href="/app">Dashboard</Link> <Link href="/app/settings">Settings</Link>
      </div>
      <main>{children}</main>
    </div>
  );
}
