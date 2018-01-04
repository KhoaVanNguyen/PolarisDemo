using Microsoft.AspNetCore.Identity;
using System;
using System.ComponentModel.DataAnnotations;

namespace server.Models
{
    public class Customer
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Phone { get; set; }
        
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime Birthday { get; set; }
        public string FamilyRegister { get; set; }
        public int Deposite { get; set; }
        public string FrontDriverImage  { get; set; }
        public string BackDriverImage { get; set; }

        public string UserId { get; set; } 
    }
}


//  `username`, `password`, `hoten`, `dienthoai`, `hokhau` là  string,
//  ngaysinh là date, 
// tiendatcoc là int, `hinhbanglaitruoc`, `hinhbanglaisau` là hình ảnh