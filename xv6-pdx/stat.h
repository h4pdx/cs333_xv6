#define T_DIR  1   // Directory
#define T_FILE 2   // File
#define T_DEV  3   // Device

#ifdef CS333_P5
union stat_mode_t {
    struct {
        uint o_x : 1;
        uint o_w : 1;
        uint o_r : 1;   // other
        uint g_x : 1;
        uint g_w : 1;
        uint g_r : 1;   // group
        uint u_x : 1;
        uint u_w : 1;
        uint u_r : 1;   // user
        uint setuid : 1;
        uint     : 22;   // padding
    } flags;
    uint asInt;
};

#endif
struct stat {
  short type;  // Type of file
  int dev;     // File system's disk device
  uint ino;    // Inode number
  short nlink; // Number of links to file
#ifdef CS333_P5
  ushort uid;           // owner ID
  ushort gid;           // group ID
  union stat_mode_t mode;    // protection/mode bits
#endif
  uint size;   // Size of file in bytes
};
