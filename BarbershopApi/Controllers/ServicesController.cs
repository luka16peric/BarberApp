using Microsoft.AspNetCore.Mvc;
using BarbershopApi.Models;

namespace BarbershopApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // URL će biti: api/services
    public class ServicesController : ControllerBase
    {
        [HttpGet]
        public ActionResult<List<BarberService>> GetServices()
        {
            // Za početak šaljemo "hardkodirane" podatke dok ne spojimo pravu bazu
            var services = new List<BarberService>
            {
                new BarberService { Id = 1, Name = "Šišanje", Price = 15.00m, DurationInMinutes = 30 },
                new BarberService { Id = 2, Name = "Uređivanje brade", Price = 10.00m, DurationInMinutes = 20 },
                new BarberService { Id = 3, Name = "Full tretman", Price = 22.00m, DurationInMinutes = 50 }
            };

            return Ok(services);
        }
    }
}