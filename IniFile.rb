#==============================================================================
# ■ IniFile
#------------------------------------------------------------------------------
# 　提供简单的INI文件读写功能。依赖于转码模块。
#------------------------------------------------------------------------------
# 　作者：失落的乐章
# 　来源：https://www.s-gs.net/ini_script
#==============================================================================

class IniFile
  WriteString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'l')
  GetString = Win32API.new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')
  
  attr_accessor :default, :buffer_size
  
  def initialize(file)
    @file = file
    @default = ""
    @buffer_size = 128
  end
  
  def [](app)
    IniKey.new(@file, app.to_s, @default, @buffer_size)
  end

  class IniKey
    def initialize(file, app, default, size)
      @file, @app, @default, @size = file, app, default, size
    end
  
    def [](key)
      buf = "\0" * @size
      GetString.call(@app.u2s, key.to_s.u2s, @default, buf, @size, @file)
      return buf.delete("\0").s2u
    end
  
    def []=(key, value)
      WriteString.call(@app.u2s, key.to_s.u2s, value.to_s.u2s, @file)
    end
  end
end