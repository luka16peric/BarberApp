using System.ComponentModel.DataAnnotations;

namespace BarbershopApi.Models
{
    public class User
    {
        [Key] // Kaže bazi da je ovo glavni ID
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;

        [Required]
        [EmailAddress] // Provjerava je li format emaila ispravan
        public string Email { get; set; } = string.Empty;

        [Required]
        public string PasswordHash { get; set; } = string.Empty;

        public string? PhoneNumber { get; set; }

        [Required]
        public string Role { get; set; } = "Client"; // "Client" ili "Barber"

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}