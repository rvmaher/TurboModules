import { TurboModule, TurboModuleRegistry } from 'react-native';

export interface ToastSpec extends TurboModule {
    showToast(message: string, duration: number): void;
}

const ToastModule = TurboModuleRegistry.get<ToastSpec>('ToastModule');

export default ToastModule;
