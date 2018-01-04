using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using server.Entities;
using server.Models;
using MySql.Data.MySqlClient;
using Microsoft.EntityFrameworkCore;

namespace server
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {

            // run table creation here

            // ===== Add our DbContext ========
            services.AddDbContext<ApplicationDbContext>();

            var connectionString = @"Server=localhost; Database=polarisdemo; Uid=root; Pwd=password";
            // using (MySql.MySqlConnection conn = connectionString) {
            //     conn.open();
            //     MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(@"
            //         create table customers (
            //         Id  int AUTO_INCREMENT PRIMARY KEY,
            //         Name varchar(50),
            //         Phone varchar(11),
            //         FamilyRegister varchar(200),
            //         Birthday date,
            //         Deposite int,
            //         FrontDriverImage text,
            //         BackDriverImage text,
            //         UserId varchar(50),
            //         foreign key (UserId) references AspNetUsers(Id)
            //         );
            //     ");
                
            //     MySql.MySqlDataReader rdr = cmd.ExecuteReader();
            //     rdr.Close();
            // }

            services.AddDbContext<AppDbContext>(ops => ops.UseMySql(connectionString: connectionString ));
            // services.AddDbContext<AppDbContext>();

            // services.AddDbContext<AppDbContext>(ops => ops.UseInMemoryDatabase("AppDb"));
            // ===== Add Identity ========
            services.AddIdentity<IdentityUser, IdentityRole>(o =>
                {
                    // configure identity options
                    o.Password.RequireDigit = false;
                    o.Password.RequireLowercase = false;
                    o.Password.RequireUppercase = false;
                    o.Password.RequireNonAlphanumeric = false;
                    o.Password.RequiredLength = 5;
                })
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddDefaultTokenProviders();

            // ===== Add Jwt Authentication ========
            JwtSecurityTokenHandler.DefaultInboundClaimTypeMap.Clear(); // => remove default claims
        

            services
                
                .AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                    
                })
                .AddJwtBearer(cfg =>
                {
                    cfg.RequireHttpsMetadata = false;
                    cfg.SaveToken = true;
                    cfg.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidIssuer = Configuration["JwtIssuer"],
                        ValidAudience = Configuration["JwtIssuer"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["JwtKey"])),
                        ClockSkew = TimeSpan.Zero // remove delay of token when expire
                    };
                });


            // ===== Add MVC ========
            services.AddMvc();
            services.AddMvc()
  .AddJsonOptions(opts =>
  {
      opts.SerializerSettings.DateFormatString = "dd/MM/yyyy";
      opts.SerializerSettings.ContractResolver = new Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver();
    
      
  });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(
            IApplicationBuilder app,
            IHostingEnvironment env,
            ApplicationDbContext dbContext
        )
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            // ===== Use Authentication ======
            app.UseAuthentication();
            app.UseMvc();

            // ===== Create tables ======
            dbContext.Database.EnsureCreated();
        }
    }
}
