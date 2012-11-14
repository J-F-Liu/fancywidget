module Kernel
  def alert(message)
    WinAPI::MessageBox(
      @hwnd, WinAPI::L(message), WinAPI::APPNAME, WinAPI::MB_ICONERROR)
  end
  def confirm(message)
  end
  def ask(message)
  end
  def ask_color(message)
  end
  def ask_open_file(message)
  end
  def ask_save_file(message)
  end
  def ask_open_folder(message)
  end
  def ask_save_folder(message)
  end
  def font(message)
  end
end