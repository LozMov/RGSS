#==============================================================================
# ■ IniFile
#------------------------------------------------------------------------------
# 　提供简单的INI文件读写功能。依赖于转码模块。
#------------------------------------------------------------------------------
# 　作者：失落的乐章
# 　来源：https://www.s-gs.net/ini_script
#==============================================================================

module INI
  WriteString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp', 'l')
  GetString = Win32API.new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')
  NULL = "\0"
end

class IniFile
  include INI
  attr_accessor :default, :buffer_size
  
  def initialize(file)
    @file = file
    @default = ""
    @buffer_size = 128
  end
  
  def [](app)
    IniKey.new(@file, app.to_s, @default, @buffer_size)
  end
end

class IniKey
  include INI
  def initialize(file, app, default, size)
    @file, @app, @default, @size = file, app, default, size
  end
  
  def [](key)
    buf = NULL * @size
    GetString.call(@app.u2s, key.to_s.u2s, @default, buf, @size, @file)
    return buf.delete(NULL).s2u
  end
  
  def []=(key, value)
    WriteString.call(@app.u2s, key.to_s.u2s, value.to_s.u2s, @file)
  end
end