#==============================================================================
# ■ HexColor
#------------------------------------------------------------------------------
# 　使Color类支持十六进制颜色表示法。
#------------------------------------------------------------------------------
# 　作者：失落的乐章
# 　来源：https://www.s-gs.net/hexcolor
#==============================================================================

=begin
================================================================================

 【版本历史】
 
 版本      日期            备注
 -----     -----------     ----------------------------------------------------
 1.0   ... 2017.05.20 ...  最初版本
 1.1   ... 2017.05.27 ...  增加对Color#set方法的修改
 1.2   ... 2017.06.12 ...  增加RGSS3中Color类的特性
________________________________________________________________________________

 【简介】
 使Color类支持十六进制颜色表示法。
 
________________________________________________________________________________

 【使用方式】
 使用形如"#FFFFFF"的字符串（#号可省略）替代形如(255,255,255)的RGB颜色数值表示。
 可使用缩略形式，如"#112233"可写作"#123"，"#000000"可写作"#0"
 示例：FireBrick = Color.new("#B22222",222)
       p FireBrick #=> (178.000000,34.000000,34.000000,222.000000)

________________________________________________________________________________

 【兼容性】
 
 暂未发现冲突情况。
                        
================================================================================
=end

class Color
  alias old_init initialize unless private_method_defined? :old_init
  alias old_set set unless method_defined? :old_set
  def initialize(r = nil, g = nil, b = nil, a = 255)
    # 判断是否采用16进制表示颜色
    if r.is_a?(String)
      g ||= 255
      a = g
      r, g, b = *hex_to_rgb(r)
      old_init(r, g, b, a)
    else
      a = 0 if (r || g || b).nil?
      r ||= 0
      g ||= 0
      b ||= 0
      old_init(r, g, b, a)
    end
  end
  
  def set(r, g = nil, b = 0, a = nil)
    if r.is_a?(String)
      g ||= self.alpha
      a = g
      r, g, b = *hex_to_rgb(r)
      old_set(r, g, b, a)
    elsif r.is_a?(Color)
      old_set(r.red, r.green, r.blue, r.alpha)
    else
      a ||= self.alpha
      old_set(r, g, b, a)
    end
  end
  
  private
  def hex_to_rgb(str)
    hex = str.delete("#")
    raise ArgumentError.new("Invalid Hex") unless /^[A-Fa-f0-9]+$/ =~ hex
    # 考虑缩写形式
    case hex.length
    when 1
      r = g = b = (hex * 2).to_i(16)
    when 3
      r, g, b = hex.split(//).map{ |s| (s * 2).to_i(16) }
    when 6
      r, g, b = [ hex[0, 2], hex[2, 2], hex[4, 2] ].map{ |s| s.to_i(16) }
    end
    return r, g, b
  end
end