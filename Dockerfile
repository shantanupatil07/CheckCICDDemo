# Use the official ASP.NET Core runtime image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official ASP.NET Core SDK image to build your application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["CheckCICDDemo.csproj", "CheckCICDDemo/"]
RUN dotnet restore "CheckCICDDemo/CheckCICDDemo.csproj"
COPY . .
WORKDIR "/src/CheckCICDDemo"
RUN dotnet build "CheckCICDDemo.csproj" -c Release -o /app/build

# Publish your application
FROM build AS publish
RUN dotnet publish "CheckCICDDemo.csproj" -c Release -o /app/publish

# Create a final image with only the published application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CheckCICDDemo.dll"]
