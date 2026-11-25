/**
 * Two Texts in a row aligned on their baselines, the second with `paddingTop: 30`.
 * Each Text's onLayout y is logged (logcat tag ReactNativeJS) and shown below the row.
 *
 * Expected: the A and the B sit on one baseline, so A's y is 30 and B's is 0.
 *
 * @format
 */

import { useState } from 'react';
import { LayoutChangeEvent, StyleSheet, Text, View } from 'react-native';

type Name = 'A' | 'B';

function App() {
  const [tops, setTops] = useState<Partial<Record<Name, number>>>({});

  const onLayoutOf = (name: Name) => (event: LayoutChangeEvent) => {
    const { y, height } = event.nativeEvent.layout;
    console.log(`Text ${name} onLayout: y=${y} height=${height}`);
    setTops(previous => ({ ...previous, [name]: y }));
  };

  return (
    <View style={styles.screen}>
      <View style={{ flexDirection: 'row', alignItems: 'baseline' }}>
        <Text style={{ fontSize: 20 }} onLayout={onLayoutOf('A')}>
          A
        </Text>
        <Text
          style={{ fontSize: 20, paddingTop: 30, backgroundColor: '#ffe08a' }}
          onLayout={onLayoutOf('B')}
        >
          B
        </Text>
      </View>
      <Text style={styles.caption}>
        B has paddingTop: 30 (yellow). Expected: A y=30, B y=0
      </Text>
      <Text style={styles.caption}>
        Actual: A y={tops.A ?? '?'}, B y={tops.B ?? '?'}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    paddingTop: 120,
    paddingHorizontal: 24,
    backgroundColor: 'white',
  },
  caption: {
    marginTop: 24,
    fontSize: 16,
    color: 'black',
  },
});

export default App;
