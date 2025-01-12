export declare class MatchMedia {
    mqlRecords: Record<string, MediaQueryList>;
    register(query: string, handler: (predicate: {
        matches: boolean;
    }) => void): void;
    unregister(query: string, handler: (predicate: {
        matches: boolean;
    }) => void): void;
    private addMqlListener;
    private removeMqlListener;
}
