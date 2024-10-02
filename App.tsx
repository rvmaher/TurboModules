import React, {useEffect} from 'react';
import {View, Button, StyleSheet} from 'react-native';
import {DeviceModule, ToastModule} from './src/turbomodules';

export default function App() {
  useEffect(() => {
    DeviceModule?.getDeviceName().then(res => {
      console.log(res, 'DEVICE NAME');
    });
    DeviceModule?.getDeviceUniqueId().then(res => {
      console.log(res, 'UNIQUE ID');
    });
  }, []);

  return (
    <View style={styles.container}>
      <Button
        title="Show Toast"
        onPress={() =>
          ToastModule?.showToast('This is a toasddsst from JS!', 1000)
        }
        color="#841584"
        accessibilityLabel="Learn more about this purple button"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
});
