# WICARAplus App

## Android release

The Play Store release is built as an Android App Bundle (AAB). Release builds
must use the existing Play upload keystore; do not generate or substitute a new
keystore for an update to the existing Play app.

1. Keep `android/key.properties` and the upload keystore local. Both are ignored
   by Git. Use `android/key.properties.example` as the format reference.
2. Confirm in Play Console that the next version code is greater than every
   version code already uploaded for this app.
3. From this directory, run:

   ```sh
   flutter pub get
   flutter test
   flutter analyze lib/main.dart lib/map_expert_page.dart test/widget_test.dart
   flutter build appbundle --release --dart-define=APP_FLAVOR=production
   ```

4. Verify that the generated bundle is signed:

   ```sh
   jarsigner -verify build/app/outputs/bundle/release/app-release.aab
   ```

The artifact to upload is
`build/app/outputs/bundle/release/app-release.aab`. This release uses version
`1.3.1` and Android version code `14`; update `version` in `pubspec.yaml` for
every subsequent Play upload. Release signing validation fails the build if
the properties or keystore file are missing. It never falls back to the debug
key. R8 code and resource shrinking are disabled for this stability release to
avoid removing code or resources used dynamically by plugins; the AAB may be
larger. Re-enable shrinking only after validating the release with Play's
pre-launch report and a representative device test.

Keep the upload keystore and its passwords backed up securely and outside the
repository. If they are lost, updates to the existing Play app may be blocked.
