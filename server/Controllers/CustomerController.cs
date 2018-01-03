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
                return BadRequest();
            }
            db.Customers.Add(customer);
            db.SaveChanges();
            return Created(new Uri("/" + customer.Id), customer );

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
