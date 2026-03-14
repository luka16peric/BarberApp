namespace BarbershopApi.Models
{
    public class BarberService
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int DurationInMinutes { get; set; }
    }
}