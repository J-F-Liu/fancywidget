require_relative 'ffi-winapi'

module FancyWidget
  class Application
    def alert(message)
      WinAPI::MessageBox(
        @hwnd, WinAPI::L(message), WinAPI::APPNAME, WinAPI::MB_ICONERROR)
    end

    def main_loop
      @hwnd = main_window.create_handle
      exit(0) if @hwnd.null?

      WinAPI::ShowWindow(@hwnd, WinAPI::SW_SHOWNORMAL)
      WinAPI::UpdateWindow(@hwnd)

      WinAPI::MSG.new { |msg|
        until WinAPI::DetonateLastError(-1, :GetMessage,
          msg, nil, 0, 0
        ) == 0
          WinAPI::TranslateMessage(msg)
          WinAPI::DispatchMessage(msg)
        end

        exit(msg[:wParam])
      }
    rescue
      alert(WinAPI::Util.FormatException($!))
      exit(1)
    end
  end
end