  !! @description: <++>
  !! @param: 
  subroutine <+routinename+>

    character (len=error_l) :: routine_name = '<+routinename+>'
    call add_backtrace(module_name, routine_name)

    call del_backtrace()

  end subroutine <+routinename+>
