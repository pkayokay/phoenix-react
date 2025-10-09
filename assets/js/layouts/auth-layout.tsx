import { Head, usePage } from "@inertiajs/react";

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  const page = usePage<{ flash: { error?: string; info?: string }; pageTitle: string }>();

  if (page.props.flash.info || page.props.flash.error) {
    alert(page.props.flash.info || page.props.flash.error);
  }
  return (
    <div>
      <Head>
        <title>{page.props.pageTitle}</title>
      </Head>
      <main>{children}</main>
    </div>
  );
}
