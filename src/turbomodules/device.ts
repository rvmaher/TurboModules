import { TurboModule, TurboModuleRegistry } from 'react-native';

export interface DeviceSpec extends TurboModule {
    getDeviceName(): Promise<string>;
    getDeviceUniqueId(): Promise<string>
}

const DeviceModule = TurboModuleRegistry.get<DeviceSpec>('DeviceModule');

export default DeviceModule;
