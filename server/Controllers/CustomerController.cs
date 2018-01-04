using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using server.Models;

namespace server.Controllers
{

    [Authorize]
    public class CustomerController : InjectedController
    {

        public CustomerController(AppDbContext context) : base(context){}
       

        [HttpGet]
        [Route("api/customers")]
        public IEnumerable<Customer> Get()
        {
            return db.Customers.ToList();
        }

        [HttpGet]
        [Route("api/customers/ById/{userId}")]
        public IActionResult GetById(string userId)
        {
            var customerInDb = db.Customers.SingleOrDefault(m => m.UserId == userId);
            if (customerInDb == null)
            {
                return StatusCode(500, new { error = "Chưa có dữ liệu khách hàng, vui lòng cập nhật" });
            }
            return StatusCode(200, new { customer = customerInDb });
        }
        [HttpPut]
        [Route("api/customers/update")]
        public IActionResult UpdateCustomer([FromBody] Customer customer)
        {

            if (!ModelState.IsValid)
            {
                return StatusCode(500, new { error = "Dữ liệu khách hàng không đúng" });
            }

            var customerInDb = db.Customers.SingleOrDefault(m => m.UserId == customer.UserId);

            if (customerInDb == null)
            {
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

            // db.SaveChangesAsync();

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
