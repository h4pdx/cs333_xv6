#ifdef CS333_P2

#define STRMAX 32

struct uproc {
    uint pid;
    uint uid;
    uint gid;
    uint ppid;
    uint elapsed_ticks;
    uint CPU_total_ticks;
    char state[STRMAX];
    uint size;
    char name[STRMAX];
};
#endif
