# Known issues and limitations

- Live Supabase sign-up/confirmation, recovery/reset, profile editing, session expiry and sign-out have not been end-to-end tested with a real development account.
- On this host, the API 37 `Medium_Phone_API_37.0` AVD using its default `auto` graphics mode showed black captures and ignored ADB taps, including native Settings interaction. Relaunching the same AVD with `-gpu host` (Intel Iris Xe) restored visible Flutter rendering and tap navigation. The emulator's persisted AVD graphics setting was not changed; relaunch with host graphics or select hardware/host graphics in Device Manager if the issue returns.
- Email delivery has not been verified and the project's SMTP settings have not been inspected. Supabase's built-in hosted sender is limited to team addresses and currently 2 messages/hour; custom SMTP is required for arbitrary recipient addresses.
- The Supabase project is a development integration. No production deployment, security audit, privacy/jurisdiction review, RLS-backed profile table, or release signing has been completed.
- The app profile currently includes only email and editable display name. The display name is stored in user-editable Auth `user_metadata` for presentation only; it is not suitable for authorization or trusted claims.
- Phone OTP, OAuth/social providers, MFA and account deletion/export are not implemented or included in the approved Phase 2 scope.
- Amharic copy still needs fluent/native review. Physical devices, additional screen sizes, large text and accessibility review remain unreported.
- Health learning/services remain placeholders. No reference APK was available, so original behavior and feature parity are not established.
- Debug APK build, static analysis, and automated tests pass; release builds/signing remain unverified (see `TESTING.md`).
