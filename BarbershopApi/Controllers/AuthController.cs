using Microsoft.AspNetCore.Mvc;
using BarbershopApi.Data;
using BarbershopApi.Models;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;

namespace BarbershopApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(User user)
        {
            // Provjeri postoji li već korisnik s tim emailom
            if (await _context.Users.AnyAsync(u => u.Email == user.Email))
            {
                return BadRequest("Korisnik s ovim emailom već postoji.");
            }

            // Kriptiraj lozinku prije spremanja
            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(user.PasswordHash);
            
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Registracija uspješna!" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
            {
                return Unauthorized("Pogrešan email ili lozinka.");
            }

            // Ovdje ćemo kasnije dodati JWT Token. Za sada vraćamo podatke o korisniku
            return Ok(new { 
                id = user.Id, 
                firstName = user.FirstName, 
                role = user.Role 
            });
        }
    }

    public class LoginRequest 
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
}