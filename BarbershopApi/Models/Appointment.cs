using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BarbershopApi.Models
{
    public class Appointment
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ClientId { get; set; }
        
        [Required]
        public int BarberId { get; set; }

        [Required]
        public int ServiceId { get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public string Status { get; set; } = "Pending"; // Pending, Confirmed, Canceled, Completed

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}