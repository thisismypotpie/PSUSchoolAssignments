#ifdef CS333_P2
int main(void)
{
  //uint o_uid, o_gid;
  uint uid , gid , ppid ;
  uid = getuid ();
  o_uid = getuid();
  printf (1 , ”Current UID is : %d\n” , uid );
  printf (1 , ”Setting UID to 100\n” );
  setuid (100);
  uid = getuid ();
  printf (1 , ”Setting UID to invalid input -1\n” );
  setuid (-1);
  printf (1 , ”Setting UID to invalid input 32768\n” );
  setuid (32768);
  printf (1 , ”Setting UID to original value.\n” );
//  setuid (o_uid);

  printf (1 , ”Current UID is : %d\n” , uid );
  gid = getgid ();
  printf (1 , ”Current GID is : %d\n” , gid );
  printf (1 , ”Setting GID to 100\n” );
  setgid (100); gid = getgid ();
  printf (1 , ”Current GID is : %d\n” , gid );
  ppid = getppid ();
  printf (1 , ”Setting GID to invalid input -1\n” );
  setgid (-1);
  printf (1 , ”Setting GID to invalid input 32768\n” );
  setgid (32768);
  printf (1 , ”Setting GID to original value.\n” );
//  setgid (o_gid);

  printf (1 , ”My parent process is : %d\n” , ppid );
  printf (1 , ”Done!\n” );

  getch();
  exit ();
}
#endif
