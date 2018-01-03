using Microsoft.AspNetCore.Identity;

namespace server.Models
{
    public class Customer
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Phone { get; set; }
        public string FamilyRegister { get; set; }
        public int Deposite { get; set; }

        public string FrontDriverImage  { get; set; }
        public string BackDriverImage { get; set; }
    }
}


//  `username`, `password`, `hoten`, `dienthoai`, `hokhau` là  string,
//  ngaysinh là date, 
// tiendatcoc là int, `hinhbanglaitruoc`, `hinhbanglaisau` là hình ảnh