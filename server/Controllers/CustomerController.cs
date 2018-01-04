using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using server.Models;

namespace server.Controllers
{
    
    public class CustomerController: InjectedController
    {
  
        public CustomerController(AppDbContext context) : base (context) {
                
        }
        
        [HttpGet]
        [Route("api/customers")]
        public IEnumerable<Customer> Get()
        {
            return db.Customers.ToList();
        }

      
        [HttpPost]
        [Route("api/customers/add")]
        public IActionResult AddCustomer([FromBody] Customer customer){
            if (!ModelState.IsValid) {
                return StatusCode(500, new { error  = "Dữ liệu khách hàng không đúng"  });
            }
            db.Customers.Add(customer);
            db.SaveChanges();
            return Created(new Uri("/" + customer.Id), new  { customer = customer, success = "Đã cập nhật khách hàng thành công"} );

        } 
        [HttpPut]
        [Route("api/customers/update")]
        public IActionResult UpdateCustomer([FromBody] Customer customer) {

            if (!ModelState.IsValid){
                return StatusCode(500, new { error = "Dữ liệu khách hàng không đúng" });
            }

            var customerInDb = db.Customers.Single( m => m.UserId == customer.UserId );

            if ( customerInDb == null ){
                db.Customers.Add(customer);
                db.SaveChanges();
                return Created(new Uri("/" + customer.Id), new { customer = customer, success = "Đã tạo mới khách hàng thành công" });
            }
            customerInDb.Name = customer.Name;
            customerInDb.Phone = customer.Phone;
            customerInDb.Birthday = customer.Birthday;
            customerInDb.Deposite = customer.Deposite;
            customerInDb.FamilyRegister = customer.FamilyRegister;
            customerInDb.FrontDriverImage = customer.FrontDriverImage;
            customerInDb.BackDriverImage = customer.BackDriverImage;
            customerInDb.UserId = customer.UserId;

            db.SaveChanges();
            return StatusCode(200, new { customer = customerInDb, success = "Đã cập nhật khách hàng thành công" });

        }
    }


    // Helper class to take care of db context injection.
    public class InjectedController : ControllerBase
    {
        protected readonly AppDbContext db;

        public InjectedController(AppDbContext context)
        {
            db = context;
        }
    }
}
