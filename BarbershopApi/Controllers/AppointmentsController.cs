using Microsoft.AspNetCore.Mvc;
using BarbershopApi.Data;
using BarbershopApi.Models;
using Microsoft.EntityFrameworkCore;

namespace BarbershopApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AppointmentsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AppointmentsController(AppDbContext context)
        {
            _context = context;
        }

        // 1. Dobivanje svih termina (da brijač vidi tko dolazi)
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Appointment>>> GetAppointments()
        {
            return await _context.Appointments.ToListAsync();
        }

        // 2. Kreiranje nove rezervacije (Ovo zoveš iz Swifta kad klikneš "Confirm")
        [HttpPost]
        public async Task<IActionResult> CreateAppointment([FromBody] Appointment appointment)
        {
            // Ovdje automatski postavljamo EndTime na temelju trajanja usluge
            var service = await _context.Services.FindAsync(appointment.ServiceId);
            if (service == null) return BadRequest("Usluga ne postoji.");

            appointment.EndTime = appointment.StartTime.AddMinutes(service.DurationInMinutes);
            appointment.CreatedAt = DateTime.UtcNow;

            _context.Appointments.Add(appointment);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Termin uspješno rezerviran!", id = appointment.Id });
        }

        // 3. Dobivanje termina za određenog korisnika
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<Appointment>>> GetUserAppointments(int userId)
        {
            return await _context.Appointments
                .Where(a => a.ClientId == userId)
                .ToListAsync();
        }
    }
}