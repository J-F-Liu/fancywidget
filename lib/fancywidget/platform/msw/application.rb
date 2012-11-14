require_relative 'ffi-winapi'

module FancyWidget
  class Application
    def alert(message)
      WinAPI::MessageBox(
        @hwnd, WinAPI::L(message), WinAPI::APPNAME, WinAPI::MB_ICONERROR)
    end

    def mainloop
      @hwnd = main_window.create_handle
      exit(0) if @hwnd.null?

      WinAPI::ShowWindow(@hwnd, WinAPI::SW_SHOWNORMAL)
      WinAPI::MSG.new { |msg|
        until msg[:message] == WinAPI::WM_QUIT
          if WinAPI::PeekMessage(msg, @hwnd, 0, 0, WinAPI::PM_REMOVE) != 0
            WinAPI::TranslateMessage(msg)
            WinAPI::DispatchMessage(msg)
          end
          sleep(0.001)
        end

        exit(msg[:wParam])
      }
    rescue Exception
      alert(WinAPI::Util.FormatException($!))
      exit(1)
    end
  end
end