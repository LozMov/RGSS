module Net
  #需要用到的部分常数
  AGENT = "RGSS"  #调用WinINet函数的应用程序
  INTERNET_OPEN_TYPE_PRECONFIG = 0  #使用IE中的连接设置
  INTERNET_SERVICE_FTP = 1  #指定服务类型为FTP
  INTERNET_DEFAULT_FTP_PORT = 21  #FTP服务器的默认端口
  #需要用到的API函数
  IO = Win32API.new('wininet','InternetOpen','plppl','l')
  IC = Win32API.new('wininet','InternetConnect','lplpplll','l')
  ICH = Win32API.new('wininet','InternetCloseHandle','l','i')
  FCD = Win32API.new('wininet','FtpCreateDirectory','lp','i')
  FDF = Win32API.new('wininet','FtpDeleteFile','lp','i')
  FGCD = Win32API.new('wininet','FtpGetCurrentDirectory','lpp','i')
  FGF = Win32API.new('wininet','FtpGetFile','lppilll','i')
  FPF = Win32API.new('wininet','FtpPutFile','lppll','i')
  FRD = Win32API.new('wininet','FtpRemoveDirectory','lp','i')
  FRF = Win32API.new('wininet','FtpRenameFile','lpp','i')
  FSCD = Win32API.new('wininet','FtpSetCurrentDirectory','lp','i')

end

class FTP
  include Net
  #--------------------------------------------------------------------------
  # ● 初始化
  #--------------------------------------------------------------------------
  def initialize(user,passwd,server,port = INTERNET_DEFAULT_FTP_PORT)
    #初始化
    @h_internet = IO.call(AGENT,INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0)
    #建立FTP Session
    @h_connect = IC.call(@h_internet,server,port,user,passwd,INTERNET_SERVICE_FTP,0,0)
  end
  #--------------------------------------------------------------------------
  # ● FtpCreateDirectory 新建文件夹
  #     dir : 新文件夹名
  #--------------------------------------------------------------------------
  def mkdir(dir)
    FCD.call(@h_connect,dir)
  end
  #--------------------------------------------------------------------------
  # ● FtpDeleteFile 删除服务器上的文件
  #     file : 目标文件名
  #--------------------------------------------------------------------------
  def delete(file)
    FDF.call(@h_connect,file)
  end
  #--------------------------------------------------------------------------
  # ● FtpGetCurrentDirectory 获取当前目录
  #--------------------------------------------------------------------------
  def pwd
    path = "\0" * 250
    FGCD.call(@h_connect,path,250)
    path.delete("\0")
  end
  #--------------------------------------------------------------------------
  # ● FtpGetFile 文件下载
  #     remote_file : 远程文件名
  #     new_file : 下载到本地后的文件名
  #     fail_if_exists : 是否覆盖同名文件（为0时覆盖，为1时下载失败），默认为0
  #     attr : 下载后文件的属性（默认为0x80，即FILE_ATTRIBUTE_NORMAL）
  #     type : 指定传输方式（1 = ASCII, 2 = BINARY），默认为2
  #--------------------------------------------------------------------------
  def get_file(remote_file,new_file,fail_if_exists = 0,attr = 0x80,type = 2)
    FGF.call(@h_connect,remote_file,new_file,fail_if_exists,attr,type,0)
  end
  #--------------------------------------------------------------------------
  # ● FtpPutFile 上传文件至服务器
  #     local_file : 本地待上传文件名
  #     new_remote_file : 上传到服务器后的文件名
  #     type : 指定传输方式（1 = ASCII, 2 = BINARY）,默认为2
  #--------------------------------------------------------------------------
  def put_file(local_file,new_remote_file,type = 2)
    FPF.call(@h_connect,local_file,new_remote_file,type,0)
  end
  #--------------------------------------------------------------------------
  # ● FtpRemoveDirectory 删除服务器上的文件夹
  #     dir : 目标文件夹名
  #--------------------------------------------------------------------------
  def rmdir(dir)
    FRD.call(@h_connect,dir)
  end
  #--------------------------------------------------------------------------
  # ● FtpRenameFile 重命名服务器上的文件
  #     existing : 目标文件名
  #     new_name : 新文件名
  #--------------------------------------------------------------------------
  def rename(existing,new_name)
    FRF.call(@h_connect,existing,new_name)
  end
  #--------------------------------------------------------------------------
  # ● FtpSetCurrentDirectory 更改当前目录
  #     dir : 新路径
  #--------------------------------------------------------------------------
  def chdir(dir)
    FSCD.call(@h_connect,dir)
  end

  #--------------------------------------------------------------------------
  # ● InternetCloseHandle 关闭连接
  #--------------------------------------------------------------------------
  def close
    ICH.call(@h_connect)
  end
  
end



#示例
=begin
ftp = FTP.new("用户名","密码","服务器IP") #连接服务器
ftp.mkdir("test") #新建文件夹
ftp.rmdir("test") #删除文件夹
ftp.get_file("remote.txt","local.txt",0,0x80,1) #用ASCII模式下载一个文本文件
ftp.close #关闭连接
=end
