#==============================================================================
# ■ EasyConv
#------------------------------------------------------------------------------
# 　转码模块。原作者不明，由失落的乐章优化。
#==============================================================================

module EasyConv
  #--------------------------------------------------------------------------
  # ● 常量定义
  #--------------------------------------------------------------------------
  CP_ACP = 0
  CP_UTF8 = 65001
  M2W = Win32API.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
  W2M = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')
  #--------------------------------------------------------------------------
  # ● 转码
  #--------------------------------------------------------------------------
  def s2u
    len = M2W.call(CP_ACP, 0, self, -1, nil, 0)
    buf = "\0" * (len*2)
    M2W.call(CP_ACP, 0, self, -1, buf, buf.size/2)
    len = W2M.call(CP_UTF8, 0, buf, -1, nil, 0, nil, nil)
    ret = "\0" * len
    W2M.call(CP_UTF8, 0, buf, -1, ret, ret.size, nil, nil)
    ret[-1] = ""
    return ret
  end
  #--------------------------------------------------------------------------
  # ● 转码
  #--------------------------------------------------------------------------
  def u2s
    len = M2W.call(CP_UTF8, 0, self, -1, nil, 0)
    buf = "\0" * (len*2)
    M2W.call(CP_UTF8, 0, self, -1, buf, buf.size/2)
    len = W2M.call(CP_ACP, 0, buf, -1, nil, 0, nil, nil)
    ret = "\0" * len
    W2M.call(CP_ACP, 0, buf, -1, ret, ret.size, nil, nil)
    return ret
  end
end

class String
  include EasyConv #混入模块
end