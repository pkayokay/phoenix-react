import { useForm } from "@inertiajs/react";

export default function ConfirmForm({ confirmed, email, token }: { confirmed: boolean; email: string; token: string }) {
  const { data, post, processing, setData, transform } = useForm({
    email: "",
    remember_me: false,
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    transform((data) => ({ user: { remember_me: data.remember_me, token: token } }));
    if (confirmed) {
      post("/app/sign_in");
    } else {
      post("/app/sign_in?_action=confirmed");
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Confirm Sign in for {email}</h1>
      <label>
        <input
          checked={data.remember_me}
          className="mr-2 inline w-fit"
          name="remember_me"
          onChange={(e) => setData("remember_me", e.target.checked)}
          type="checkbox"
        />
        Remember me
      </label>
      <button disabled={processing} type="submit">
        Confirm
      </button>
    </form>
  );
}
