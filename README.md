# text-baseline-leaves-out-padding

A `Text`'s baseline leaves out its top padding, so `alignItems: 'baseline'` places a padded `Text` as if it had none.

`ReproducerApp/App.tsx` renders:

```jsx
<View style={{ flexDirection: 'row', alignItems: 'baseline' }}>
  <Text style={{ fontSize: 20 }}>A</Text>
  <Text style={{ fontSize: 20, paddingTop: 30, backgroundColor: '#ffe08a' }}>B</Text>
</View>
```

Each `Text` logs its `onLayout` y (logcat tag `ReactNativeJS`), and the screen shows both below the row.

## Run it

With an Android device on adb (`ANDROID_SERIAL` picks one):

```sh
./reproduce-android.sh
```

It builds the app in Release, installs and launches it, takes a screenshot (`screenshot.png`), dumps the app's log
(`logcat.txt`) and runs `./verdict.sh logcat.txt`, which reads the last y each `Text` logged.

Or by hand: `cd ReproducerApp && yarn install && yarn android`, then read the screen.

- **Expected:** the A and the B sit on one baseline: A's y is 30 and B's is 0; the script exits 0.
- **Actual:** both `Text`s' tops sit at y 0, so the B sits 30 below the A; the script exits 1.

It exits 2 when a step fails or the log cannot tell.
