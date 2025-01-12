export * from './carousel-utils';
export * from './match-media';
export declare const canUseDOM: () => boolean;
export declare const filterUndefined: <T extends object>(props: T) => T;
export declare function clearSelection(): void;
export declare function json2mq(obj: Record<string, any>): string;
export declare function debounce(callback: () => Promise<void>, wait: number): {
    cancel: () => void;
};
