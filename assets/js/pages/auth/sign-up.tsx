import { Link, useForm } from "@inertiajs/react";

export default function SignUp() {
  const { data, errors, post, processing, setData, transform } = useForm({
    email: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    transform((data) => ({ user: data }));
    post("/app/sign_up");
  }

  return (
    <form onSubmit={handleSubmit}>
      <h1>Register</h1>
      <input autoComplete="username" autoFocus name="email" onChange={(e) => setData("email", e.target.value)} type="email" value={data.email} />
      {errors.email && <p className="text-red-500">Email {errors.email}</p>}
      <button disabled={processing} type="submit">
        Sign up
      </button>
      <Link href={"/app/sign_in"}>Already have an account? Log in</Link>
    </form>
  );
}
