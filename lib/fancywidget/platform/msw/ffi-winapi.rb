require 'ffi'

module WinAPI
  extend FFI::Library

  module Util
    def FormatException(ex)
      str, trace = ex.to_s, ex.backtrace
      str << "\n\n-- backtrace --\n\n" << trace.join("\n") if trace
      str
    end

    module_function :FormatException

    Id2Ref = {}

    def Id2RefTrack(object)
      Id2Ref[object.object_id] = object
      ObjectSpace.define_finalizer(object, -> id {
        Id2Ref.delete(id)
      })
    end

    module_function :Id2RefTrack

    unless FFI::Struct.respond_to?(:by_ref)
      class << FFI::Struct
        def by_ref(*args)
          FFI::Type::Builtin::POINTER
        end
      end
    end

    module ScopedStruct
      def new(*args)
        raise ArgumentError, 'Cannot accept both arguments and a block' if
          args.length > 0 && block_given?

        struct = super
        return struct unless block_given?

        begin
          yield struct
        ensure
          struct.pointer.free
          p "Native memory for #{struct} freed" if $DEBUG
        end

        nil
      end
    end
  end

  #{ INVALID_xxx
  INVALID_HANDLE_VALUE = FFI::Pointer.new(-1)
  #}

  def MAKEWORD(lobyte, hibyte)
    (lobyte & 0xff) | ((hibyte & 0xff) << 8)
  end

  def LOBYTE(word)
    word & 0xff
  end

  def HIBYTE(word)
    (word >> 8) & 0xff
  end

  module_function :MAKEWORD, :LOBYTE, :HIBYTE

  def MAKELONG(loword, hiword)
    (loword & 0xffff) | ((hiword & 0xffff) << 16)
  end

  def LOWORD(long)
    long & 0xffff
  end

  def HIWORD(long)
    (long >> 16) & 0xffff
  end

  def LOSHORT(long)
    ((loshort = LOWORD(long)) > 0x7fff) ? loshort - 0x1_0000 : loshort
  end

  def HISHORT(long)
    ((hishort = HIWORD(long)) > 0x7fff) ? hishort - 0x1_0000 : hishort
  end

  module_function :MAKELONG, :LOWORD, :HIWORD, :LOSHORT, :HISHORT

  def L(str)
    (str << "\0").encode!('utf-16le')
  end

  def PWSTR(wstr)
    raise 'Invalid Unicode string' unless
      wstr.encoding == Encoding::UTF_16LE && wstr[-1] == L('')

    ptr = FFI::MemoryPointer.new(:ushort, wstr.length).
      put_bytes(0, wstr)

    return ptr unless block_given?

    begin
      yield ptr
    ensure
      ptr.free

      p "Native copy of '#{wstr[0...-1].encode($0.encoding)}' freed" if $DEBUG
    end

    nil
  end

  module_function :L, :PWSTR

  APPNAME = L(File.basename($0, '.rbw'))

  class POINT < FFI::Struct
    extend Util::ScopedStruct
    layout :x, :long, :y, :long
  end

  class SIZE < FFI::Struct
    extend Util::ScopedStruct
    layout :cx, :long, :cy, :long
  end

  class RECT < FFI::Struct
    extend Util::ScopedStruct

    layout \
      :left, :long,
      :top, :long,
      :right, :long,
      :bottom, :long
  end

  ffi_lib 'kernel32'
  ffi_convention :stdcall

  attach_function :SetLastError, [:ulong ], :void
  attach_function :GetLastError, [], :ulong
  attach_function :GetModuleHandle, :GetModuleHandleW, [:buffer_in ], :pointer

  def Detonate(on, name, *args)
    raise "#{name} failed" if
      (failed = [*on].include?(result = send(name, *args)))

    result
  ensure
    yield failed if block_given?
  end

  def DetonateLastError(on, name, *args)
    raise "#{name} failed (last error: #{GetLastError()})" if
      (failed = [*on].include?(result = send(name, *args)))

    result
  ensure
    yield failed if block_given?
  end

  module_function :Detonate, :DetonateLastError

  class OSVERSIONINFOEX < FFI::Struct
    extend Util::ScopedStruct

    layout \
      :dwOSVersionInfoSize, :ulong,
      :dwMajorVersion, :ulong,
      :dwMinorVersion, :ulong,
      :dwBuildNumber, :ulong,
      :dwPlatformId, :ulong,
      :szCSDVersion, [:ushort, 128],
      :wServicePackMajor, :ushort,
      :wServicePackMinor, :ushort,
      :wSuiteMask, :ushort,
      :wProductType, :uchar,
      :wReserved, :uchar
  end

  attach_function :GetVersionEx, :GetVersionExW, [
    OSVERSIONINFOEX.by_ref
  ], :int

  OSVERSION = OSVERSIONINFOEX.new.tap { |ovi|
    at_exit { OSVERSION.pointer.free }

    ovi[:dwOSVersionInfoSize] = ovi.size

    DetonateLastError(0, :GetVersionEx,
      ovi
    )
  }

    #{ NTDDI_xxx
  NTDDI_WIN2K = 0x0500_0000

  NTDDI_WIN2KSP1 = 0x0500_0100
  NTDDI_WIN2KSP2 = 0x0500_0200
  NTDDI_WIN2KSP3 = 0x0500_0300
  NTDDI_WIN2KSP4 = 0x0500_0400

  NTDDI_WINXP = 0x0501_0000

  NTDDI_WINXPSP1 = 0x0501_0100
  NTDDI_WINXPSP2 = 0x0501_0200
  NTDDI_WINXPSP3 = 0x0501_0300
  NTDDI_WINXPSP4 = 0x0501_0400

  NTDDI_WS03 = 0x0502_0000

  NTDDI_WS03SP1 = 0x0502_0100
  NTDDI_WS03SP2 = 0x0502_0200
  NTDDI_WS03SP3 = 0x0502_0300
  NTDDI_WS03SP4 = 0x0502_0400

  NTDDI_VISTA = 0x0600_0000

  NTDDI_VISTASP1 = 0x0600_0100
  NTDDI_VISTASP2 = 0x0600_0200
  NTDDI_VISTASP3 = 0x0600_0300
  NTDDI_VISTASP4 = 0x0600_0400

  NTDDI_WS08 = NTDDI_VISTASP1

  NTDDI_WS08SP2 = NTDDI_VISTASP2
  NTDDI_WS08SP3 = NTDDI_VISTASP3
  NTDDI_WS08SP4 = NTDDI_VISTASP4

  NTDDI_WIN7 = 0x0601_0000
  #}

  NTDDI_VERSION = MAKELONG(
    MAKEWORD(OSVERSION[:wServicePackMinor], OSVERSION[:wServicePackMajor]),
    MAKEWORD(OSVERSION[:dwMinorVersion], OSVERSION[:dwMajorVersion])
  )

  #{ WINxxx
  WIN2K = 0x0500
  WINXP = 0x0501
  WINVISTA = 0x0600
  WIN7 = 0x0601
  #}

  WINVER = HIWORD(NTDDI_VERSION)

  ffi_lib 'gdi32'
  ffi_convention :stdcall

  class RGBQUAD < FFI::Struct
    extend Util::ScopedStruct
    layout \
      :Blue, :uchar,
      :Green, :uchar,
      :Red, :uchar,
      :Reserved, :uchar
  end

  class BITMAPINFOHEADER < FFI::Struct
    extend Util::ScopedStruct
    layout \
      :size, :uint32,
      :width, :long,
      :height, :long,
      :planes, :ushort,
      :bitCount, :ushort,
      :compression, :uint32,
      :sizeImage, :uint32,
      :xPelsPerMeter, :long,
      :yPelsPerMeter, :long,
      :clrUsed, :uint32,
      :clrImportant, :uint32
  end

  class BITMAPINFO < FFI::Struct
    extend Util::ScopedStruct
    layout \
      :header, BITMAPINFOHEADER,
      :colors, RGBQUAD
  end

  #{ DIB_xxx
  DIB_RGB_COLORS = 0
  DIB_PAL_COLORS = 1
  #}

  BI_RGB = 0
  BI_RLE8 = 1
  BI_RLE4 = 2
  SRCCOPY = 0x00CC0020

  attach_function :SelectObject, [:pointer, :pointer], :pointer
  attach_function :BitBlt, [:long, :int, :int, :int, :int, :long, :int, :int, :long], :bool
  attach_function :SetDIBitsToDevice, [:pointer, :int, :int, :long, :long, :int, :int, :uint, :uint, :pointer, BITMAPINFO.by_ref(:in), :uint], :int
  attach_function :StretchDIBits, [:pointer, :int, :int, :int, :int, :int, :int, :int, :int, :pointer, BITMAPINFO.by_ref(:in), :uint, :uint32], :int

  def UseObjects(hdc, *hgdiobjs)
    holds = []

    hgdiobjs.each { |hgdiobj|
      holds << DetonateLastError([FFI::Pointer::NULL, HGDI_ERROR], :SelectObject,
        hdc, hgdiobj
      )
    }

    yield
  ensure
    holds.each { |hgdiobj|
      SelectObject(hdc, hgdiobj)
    }
  end

  module_function :UseObjects

  ffi_lib 'user32'
  ffi_convention :stdcall

  attach_function :GetWindowDC, [:pointer ], :pointer
  attach_function :GetDC, [:pointer ], :pointer
  attach_function :ReleaseDC, [:pointer, :pointer ], :int
  def UseWindowDC(hwnd)
    hdc = DetonateLastError(FFI::Pointer::NULL, :GetWindowDC, hwnd)
    begin
      yield hdc
    ensure
      ReleaseDC(hwnd, hdc)
    end
  end

  def UseDC(hwnd)
    hdc = DetonateLastError(FFI::Pointer::NULL, :GetDC, hwnd)
    begin
      yield hdc
    ensure
      ReleaseDC(hwnd, hdc)
    end
  end

  module_function :UseWindowDC, :UseDC

  #{ MB_xxx
  MB_OK = 0x0000_0000
  MB_OKCANCEL = 0x0000_0001
  MB_YESNO = 0x0000_0004
  MB_YESNOCANCEL = 0x0000_0003
  MB_RETRYCANCEL = 0x0000_0005
  MB_ABORTRETRYIGNORE = 0x0000_0002
  MB_CANCELTRYCONTINUE = 0x0000_0006
  MB_HELP = 0x0000_4000

  MB_ICONINFORMATION = 0x0000_0040
  MB_ICONWARNING = 0x0000_0030
  MB_ICONERROR = 0x0000_0010
  MB_ICONQUESTION = 0x0000_0020

  MB_DEFBUTTON1 = 0x0000_0000
  MB_DEFBUTTON2 = 0x0000_0100
  MB_DEFBUTTON3 = 0x0000_0200
  MB_DEFBUTTON4 = 0x0000_0300

  MB_APPLMODAL = 0x0000_0000
  MB_TASKMODAL = 0x0000_2000
  MB_SYSTEMMODAL = 0x0000_1000
  #}

  #{ IDxxx
  IDOK = 1
  IDCANCEL = 2
  IDYES = 6
  IDNO = 7
  IDABORT = 3
  IDRETRY = 4
  IDIGNORE = 5
  IDTRYAGAIN = 10
  IDCONTINUE = 11
  if WINVER >= WINXP # IDTIMEOUT
    IDTIMEOUT = 32000
  end
  #}

  #{ IDI_xxx
  IDI_WINLOGO = FFI::Pointer.new(32517)
  IDI_APPLICATION = FFI::Pointer.new(32512)
  if WINVER >= WINVISTA # IDI_SHIELD
    IDI_SHIELD = FFI::Pointer.new(32518)
  end

  IDI_INFORMATION = FFI::Pointer.new(32516)
  IDI_WARNING = FFI::Pointer.new(32515)
  IDI_ERROR = FFI::Pointer.new(32513)
  IDI_QUESTION = FFI::Pointer.new(32514)
  #}

  #{ IDC_xxx
  IDC_WAIT = FFI::Pointer.new(32514)
  IDC_APPSTARTING = FFI::Pointer.new(32650)

  IDC_ARROW = FFI::Pointer.new(32512)
  IDC_HAND = FFI::Pointer.new(32649)
  IDC_IBEAM = FFI::Pointer.new(32513)
  IDC_CROSS = FFI::Pointer.new(32515)
  IDC_HELP = FFI::Pointer.new(32651)
  IDC_NO = FFI::Pointer.new(32648)

  IDC_SIZEALL = FFI::Pointer.new(32646)
  IDC_SIZENS = FFI::Pointer.new(32645)
  IDC_SIZEWE = FFI::Pointer.new(32644)
  IDC_SIZENWSE = FFI::Pointer.new(32642)
  IDC_SIZENESW = FFI::Pointer.new(32643)
  #}


  attach_function :MessageBox, :MessageBoxW, [:pointer, :buffer_in, :buffer_in, :uint ], :int
  attach_function :SendMessage, :SendMessageW, [:pointer, :uint, :uint, :long ], :long
  attach_function :PostMessage, :PostMessageW, [:pointer, :uint, :uint, :long ], :int
  attach_function :PostQuitMessage, [:int ], :void

  callback :WNDPROC, [:pointer, :uint, :uint, :long ], :long
  attach_function :DefWindowProc, :DefWindowProcW, [:pointer, :uint, :uint, :long ], :long
  attach_function :LoadIcon, :LoadIconW, [:pointer, :buffer_in ], :pointer
  attach_function :LoadCursor, :LoadCursorW, [:pointer, :buffer_in ], :pointer

  #{ COLOR_xxx
  COLOR_DESKTOP = 1
  COLOR_APPWORKSPACE = 12
  COLOR_WINDOW = 5
  if WINVER >= WINXP # COLOR_MENUBAR
    COLOR_MENUBAR = 30
  end
  COLOR_MENU = 4
  #}

  class WNDCLASSEX < FFI::Struct
    extend Util::ScopedStruct

    layout \
      :cbSize, :uint,
      :style, :uint,
      :lpfnWndProc, :WNDPROC,
      :cbClsExtra, :int,
      :cbWndExtra, :int,
      :hInstance, :pointer,
      :hIcon, :pointer,
      :hCursor, :pointer,
      :hbrBackground, :pointer,
      :lpszMenuName, :pointer,
      :lpszClassName, :pointer,
      :hIconSm, :pointer
  end

  class MSG < FFI::Struct
    extend Util::ScopedStruct
    layout \
      :hwnd, :pointer,
      :message, :uint,
      :wParam, :uint,
      :lParam, :long,
      :time, :ulong,
      :pt, POINT
  end

  #{ PM_xxx
  PM_NOREMOVE = 0x0000
  PM_REMOVE = 0x0001
  PM_NOYIELD = 0x0002
  #}


  attach_function :RegisterClassEx, :RegisterClassExW, [WNDCLASSEX.by_ref(:in) ], :ushort
  attach_function :PeekMessage, :PeekMessageW, [MSG.by_ref(:out), :pointer, :uint, :uint, :uint ], :int
  attach_function :GetMessage, :GetMessageW, [MSG.by_ref(:out), :pointer, :uint, :uint ], :int
  attach_function :IsDialogMessage, [:pointer, MSG.by_ref(:in) ], :int
  attach_function :TranslateAccelerator, :TranslateAcceleratorW, [:pointer, :pointer, MSG.by_ref(:in) ], :int
  attach_function :TranslateMessage, [MSG.by_ref(:in) ], :int
  attach_function :DispatchMessage, :DispatchMessageW, [MSG.by_ref(:in) ], :long

  #{ GWL_xxx
  GWL_WNDPROC = -4
  GWL_EXSTYLE = -20
  GWL_STYLE = -16
  GWL_HWNDPARENT = -8
  GWL_ID = -12
  GWL_HINSTANCE = -6
  GWL_USERDATA = -21
  #}

  #{ SW_xxx
  SW_SHOWDEFAULT = 10
  SW_HIDE = 0
  SW_SHOW = 5
  SW_SHOWNA = 8
  SW_SHOWNORMAL = 1
  SW_SHOWNOACTIVATE = 4
  SW_SHOWMINIMIZED = 2
  SW_SHOWMINNOACTIVE = 7
  SW_MINIMIZE = 6
  SW_FORCEMINIMIZE = 11
  SW_SHOWMAXIMIZED = 3
  SW_MAXIMIZE = 3
  SW_RESTORE = 9
  #}

  #{ WS_xxx
  WS_BORDER = 0x0080_0000
  WS_DLGFRAME = 0x0040_0000
  WS_CAPTION = 0x00c0_0000
  WS_SYSMENU = 0x0008_0000
  WS_THICKFRAME = 0x0004_0000
  WS_MINIMIZEBOX = 0x0002_0000
  WS_MAXIMIZEBOX = 0x0001_0000
  WS_HSCROLL = 0x0010_0000
  WS_VSCROLL = 0x0020_0000

  WS_DISABLED = 0x0800_0000
  WS_VISIBLE = 0x1000_0000
  WS_MINIMIZE = 0x2000_0000
  WS_MAXIMIZE = 0x0100_0000
  WS_CLIPCHILDREN = 0x0200_0000

  WS_GROUP = 0x0002_0000
  WS_TABSTOP = 0x0001_0000
  WS_CLIPSIBLINGS = 0x0400_0000

  WS_OVERLAPPED = 0x0000_0000
  WS_OVERLAPPEDWINDOW = WS_OVERLAPPED |
    WS_CAPTION | WS_SYSMENU |
    WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX
  WS_POPUP = 0x8000_0000
  WS_POPUPWINDOW = WS_POPUP |
    WS_BORDER | WS_SYSMENU
  WS_CHILD = 0x4000_0000
  WS_CHILDWINDOW = WS_CHILD
  #}

  #{ CW_xxx
  CW_USEDEFAULT = 0x8000_0000 - 0x1_0000_0000
  #}

  attach_function :ShowWindow, [:pointer, :int ], :int
  attach_function :UpdateWindow, [:pointer ], :int

  WM_NCCREATE = 0x0081
  WM_CREATE = 0x0001
  WM_INITDIALOG = 0x0110
  WM_CLOSE = 0x0010
  WM_DESTROY = 0x0002
  WM_NCDESTROY = 0x0082
  WM_QUIT = 0x0012

  WM_PAINT = 0x000f
  WM_PRINT = 0x0317
  WM_PRINTCLIENT = 0x0318

  WM_LBUTTONDOWN = 0x0201
  WM_LBUTTONUP = 0x0202
  WM_LBUTTONDBLCLK = 0x0203

  WM_RBUTTONDOWN = 0x0204
  WM_RBUTTONUP = 0x0205
  WM_RBUTTONDBLCLK = 0x0206

  WM_MBUTTONDOWN = 0x0207
  WM_MBUTTONUP = 0x0208
  WM_MBUTTONDBLCLK = 0x0209

  WM_MOUSEWHEEL = 0x020a
  if WINVER >= WINVISTA # WM_MOUSEHWHEEL
    WM_MOUSEHWHEEL = 0x020e
  end

  WM_MOUSEMOVE = 0x0200

  WM_SYSKEYDOWN = 0x0104
  WM_SYSKEYUP = 0x0105

  WM_SYSCHAR = 0x0106
  WM_SYSDEADCHAR = 0x0107

  WM_KEYDOWN = 0x0100
  WM_KEYUP = 0x0101

  WM_CHAR = 0x0102
  WM_DEADCHAR = 0x0103

  RDW_ERASE = 4
  RDW_FRAME = 1024
  RDW_INTERNALPAINT = 2
  RDW_INVALIDATE = 1
  RDW_NOERASE = 32
  RDW_NOFRAME = 2048
  RDW_NOINTERNALPAINT = 16
  RDW_VALIDATE = 8
  RDW_ERASENOW = 512
  RDW_UPDATENOW = 256
  RDW_ALLCHILDREN = 128
  RDW_NOCHILDREN = 64

  attach_function :CreateWindowEx, :CreateWindowExW, [
    :ulong,
    :buffer_in,
    :buffer_in,
    :ulong,
    :int,
    :int,
    :int,
    :int,
    :pointer,
    :pointer,
    :pointer,
    :pointer
  ], :pointer

  attach_function :GetWindowRect, [:pointer, RECT.by_ref(:out) ], :int
  attach_function :GetClientRect, [:pointer, RECT.by_ref(:out) ], :int
  attach_function :ScreenToClient, [:pointer, POINT.by_ref ], :int
  attach_function :ClientToScreen, [:pointer, POINT.by_ref ], :int
  attach_function :InvalidateRect, [:pointer, RECT.by_ref(:in), :int ], :int
  attach_function :GetUpdateRect, [:pointer, RECT.by_ref(:out), :int ], :int
  attach_function :UpdateWindow, [:pointer ], :int
  attach_function :RedrawWindow, [:pointer, RECT.by_ref(:in), :pointer, :int ], :int
  attach_function :GetWindowLong, :GetWindowLongW, [:pointer, :int ], :long

  class PAINTSTRUCT < FFI::Struct
    extend Util::ScopedStruct

    layout \
      :hdc, :pointer,
      :fErase, :int,
      :rcPaint, RECT,
      :fRestore, :int,
      :fIncUpdate, :int,
      :rgbReserved, [:uchar, 32]
  end

  attach_function :BeginPaint, [:pointer, PAINTSTRUCT.by_ref(:out) ], :pointer
  attach_function :EndPaint, [:pointer, PAINTSTRUCT.by_ref(:in) ], :int

  def DoPaint(hwnd)
    return unless GetUpdateRect(hwnd, nil, 0) != 0

    PAINTSTRUCT.new { |ps|
      DetonateLastError(FFI::Pointer::NULL, :BeginPaint, hwnd, ps)
      begin
        yield ps
      ensure
        EndPaint(hwnd, ps)
      end
    }
  end

  def DoPrintClient(hwnd, wParam)
    PAINTSTRUCT.new { |ps|
      ps[:hdc] = FFI::Pointer.new(wParam)
      ps[:fErase] = 1
      GetClientRect(hwnd, ps[:rcPaint])
      yield ps
    }
  end

  module_function :DoPaint, :DoPrintClient
end