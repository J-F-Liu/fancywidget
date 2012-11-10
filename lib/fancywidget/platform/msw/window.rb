require_relative 'ffi-winapi'

module FancyWidget
  class Window
    def onDestroy(hwnd)
      WinAPI::PostQuitMessage(0); 0
    end

    def onPaint(hwnd, ps)
      WinAPI::UseObjects(ps[:hdc]) {
        WinAPI::BITMAPINFO.new { |bmpinfo|
          bmpinfo[:header][:size] = bmpinfo[:header].size
          bmpinfo[:header][:width] = self.width
          bmpinfo[:header][:height] = self.height
          bmpinfo[:header][:compression] = WinAPI::BI_RGB
          bmpinfo[:header][:planes] = 1
          bmpinfo[:header][:bitCount] = 32
          WinAPI::StretchDIBits(ps[:hdc], 0, 0, self.width, self.height,
           0, self.height, self.width, -self.height, self.canvas.data,
           bmpinfo, WinAPI::DIB_RGB_COLORS, WinAPI::SRCCOPY)
        }
      }

      0
    end

    def create_message_processor
      return FFI::Function.new(:long,
        [:pointer, :uint, :uint, :long],
        convention: :stdcall
      ) { |hwnd, uMsg, wParam, lParam|
      begin
        result = case uMsg
        when WinAPI::WM_DESTROY
          onDestroy(hwnd)
        when WinAPI::WM_PAINT
          WinAPI::DoPaint(hwnd) { |ps| result = onPaint(hwnd, ps) }
        when WinAPI::WM_PRINTCLIENT
          WinAPI::DoPrintClient(hwnd, wParam) { |ps| result = onPaint(hwnd, ps) }
        end

        result || WinAPI::DefWindowProc(hwnd, uMsg, wParam, lParam)
      rescue SystemExit => ex
        WinAPI::PostQuitMessage(ex.status)
      rescue
        case WinAPI::MessageBox(hwnd,
          WinAPI::L(WinAPI::Util.FormatException($!)),
          WinAPI::APPNAME,
          WinAPI::MB_ABORTRETRYIGNORE | WinAPI::MB_ICONERROR
        )
        when WinAPI::IDABORT
          WinAPI::PostQuitMessage(2)
        when WinAPI::IDRETRY
          retry
        end
      end
      }
    end

    def create_handle
      window_proc = create_message_processor
      WinAPI::WNDCLASSEX.new { |wc|
        wc[:cbSize] = wc.size
        wc[:lpfnWndProc] = window_proc
        wc[:hInstance] = WinAPI::GetModuleHandle(nil)
        wc[:hIcon] = WinAPI::LoadIcon(nil, WinAPI::IDI_APPLICATION)
        wc[:hCursor] = WinAPI::LoadCursor(nil, WinAPI::IDC_ARROW)
        wc[:hbrBackground] = FFI::Pointer.new(
          ((WinAPI::WINVER == WinAPI::WINXP) ? WinAPI::COLOR_MENUBAR : WinAPI::COLOR_MENU) + 1
        )
        WinAPI::PWSTR(WinAPI::APPNAME) { |className|
          wc[:lpszClassName] = className
          WinAPI::DetonateLastError(0, :RegisterClassEx, wc)
        }
      }
      
      hwnd = WinAPI::CreateWindowEx(
        0, WinAPI::APPNAME, WinAPI::L(self.title),
        WinAPI::WS_OVERLAPPEDWINDOW | WinAPI::WS_CLIPCHILDREN,
        WinAPI::CW_USEDEFAULT, WinAPI::CW_USEDEFAULT,
        self.width+20, self.height+50,
        nil, nil, WinAPI::GetModuleHandle(nil), nil
      )

      raise "CreateWindowEx failed (last error: #{WinAPI::GetLastError()})" if
        hwnd.null? && WinAPI::GetLastError() != 0

      return hwnd
    end
  end
end