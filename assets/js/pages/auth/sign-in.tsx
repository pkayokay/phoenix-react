import { Link, useForm } from "@inertiajs/react";

export default function SignIn() {
  return (
    <div>
      <MagicLinkForm />
      <br />
      <PasswordForm />
      <Link href={"/app/sign_up"}>Don&#39;t have an account? Sign up</Link>
    </div>
  );
}

const MagicLinkForm = () => {
  const { data, post, processing, reset, setData, transform } = useForm({ email: "" });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    transform((data) => ({ user: { email: data.email } }));
    post("/app/sign_in", {
      onSuccess: () => reset(),
    });
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Log in</h1>
      <input autoComplete="username" autoFocus name="email" onChange={(e) => setData("email", e.target.value)} type="email" value={data.email} />
      <button disabled={processing} type="submit">
        Send magic link
      </button>
    </form>
  );
};

const PasswordForm = () => {
  const { data, post, processing, setData, transform } = useForm({
    email: "",
    password: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    transform((data) => ({
      user: { email: data.email, password: data.password },
    }));

    post("/app/sign_in", {
      onFinish: () => {
        setData("password", "");
      },
    });
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Log in</h1>
      <input autoComplete="username" autoFocus name="email" onChange={(e) => setData("email", e.target.value)} type="email" value={data.email} />
      <br />
      <input
        autoComplete="current-password"
        maxLength={72}
        name="password"
        onChange={(e) => setData("password", e.target.value)}
        type="password"
        value={data.password}
      />
      <br />
      <button disabled={processing} type="submit">
        Sign in
      </button>
    </form>
  );
};
