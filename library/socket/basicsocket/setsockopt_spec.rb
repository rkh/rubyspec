require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/classes'

describe "BasicSocket#setsockopt" do
  
  before(:each) do
    @sock = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
  end

  after :each do
    @sock.close unless @sock.closed?
  end

  it "sets the socket linger to 0" do
    linger = [0, 0].pack("ii")
    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, linger).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER)
    n.should == [0].pack("i")
  end

  it "sets the socket linger to some positive value" do
    linger = [64, 64].pack("ii")
    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, linger).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER)
    n.should == [64].pack("i")
  end

  it "sets the send buffer size with Socket::SO_SNDBUF" do
    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, 4000).should == 0
    sndbuf = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    sndbuf.unpack('i')[0].should == 4000
  end

  it "sets the socket option Socket::SO_OOBINLINE" do
    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, true).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, false).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [0].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, 1).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, 0).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [0].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, 2).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, "").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [0].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, "blah").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, "0").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, "\x00\x00\x00\x00").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [0].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, "1").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, "\x00\x00\x00").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [0].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, [1].pack('i')).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, [0].pack('i')).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [0].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE, [1000].pack('i')).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_OOBINLINE)
    n.should == [1].pack("i")
  end

  it "sets the socket option Socket::SO_SNDBUF" do
    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, true).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    n.should == [1].pack("i")

    lambda {
      @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, nil).should == 0
    }.should raise_error(TypeError)

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, 1).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, 2).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    n.should == [2].pack("i")

    lambda {
      @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, "")
    }.should raise_error(SystemCallError)

    lambda {
      @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, "bla")
    }.should raise_error(SystemCallError)

    lambda {
      @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, "0")
    }.should raise_error(SystemCallError)

    lambda {
      @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, "1")
    }.should raise_error(SystemCallError)

    lambda {
      @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, "\x00\x00\x00")
    }.should raise_error(SystemCallError)

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, "\x00\x00\x01\x00").should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    n.should == ["\x00\x00\x01\x00".unpack('i')[0]].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, [1].pack('i')).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    n.should == [1].pack("i")

    @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF, [1000].pack('i')).should == 0
    n = @sock.getsockopt(Socket::SOL_SOCKET, Socket::SO_SNDBUF)
    n.should == [1000].pack("i")
  end
end
