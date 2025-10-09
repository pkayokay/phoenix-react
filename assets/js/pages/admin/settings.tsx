import { useForm, usePage } from "@inertiajs/react";

import { Heading } from "../ui/heading";

export default function Settings() {
  const page = usePage<{ currentUser: { email: string } }>();

  return (
    <div>
      <Heading text="Dashboard" />
      <p>
        Logged in as <strong>{page.props.currentUser.email}</strong>
      </p>
      <br />
      <UpdateEmailForm />
      <br />
      <UpdatePasswordForm />
    </div>
  );
}

const UpdateEmailForm = () => {
  const { data, processing, put, setData, transform } = useForm({
    email: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    transform((data) => ({ action: "update_email", user: { email: data.email } }));
    put("/app/settings");
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Change email</h1>
      <input autoComplete="username" autoFocus name="email" onChange={(e) => setData("email", e.target.value)} type="email" value={data.email} />
      <button disabled={processing} type="submit">
        Change email
      </button>
    </form>
  );
};

const UpdatePasswordForm = () => {
  const { data, processing, put, setData, transform } = useForm({
    password: "",
    password_confirmation: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();

    transform((data) => ({
      action: "update_password",
      user: {
        password: data.password,
        password_confirmation: data.password_confirmation,
      },
    }));

    put("/app/settings");
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Change password</h1>

      <input
        autoComplete="current-password"
        maxLength={72}
        name="password"
        onChange={(e) => setData("password", e.target.value)}
        type="password"
        value={data.password}
      />
      <br />
      <input
        autoComplete="current-password"
        maxLength={72}
        name="password_confirmation"
        onChange={(e) => setData("password_confirmation", e.target.value)}
        type="password"
        value={data.password_confirmation}
      />
      <button disabled={processing} type="submit">
        Change password
      </button>
    </form>
  );
};
