
using Microsoft.EntityFrameworkCore;

namespace server.Models
{
    public class AppDbContext: DbContext
    {
        public DbSet<Customer> Customers { get; set; }
        public AppDbContext(DbContextOptions options) : base(options) { 


        }
        
        
    }
    
}