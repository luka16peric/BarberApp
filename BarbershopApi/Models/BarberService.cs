using System.ComponentModel.DataAnnotations;

namespace BarbershopApi.Models
{
    public class BarberService
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; } = string.Empty;

        public string? Description { get; set; }

        [Required]
        public decimal Price { get; set; }

        [Required]
        public int DurationInMinutes { get; set; }
    }
}