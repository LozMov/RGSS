module Graphics
  #取得窗口句柄
  HWND = Win32API.new('user32','GetActiveWindow',nil,'l').call
  def self.fullscreen?
    #取得窗口范围矩形
    window_rect = "\0" * 16
    Win32API.new('user32','GetWindowRect',['l','p'],'i').call(HWND,window_rect)
    wl,wt,wr,wb = window_rect.unpack('llll')
    #取得客户区矩形
    client_rect = "\0" * 16
    Win32API.new('user32','GetClientRect',['l','p'],'i').call(HWND,client_rect)
    cl,ct,cr,cb = client_rect.unpack('llll')
    wr - wl == cr
  end
end
