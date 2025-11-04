// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'dart:io'; // Necesario para el tipo File
import 'package:image_picker/image_picker.dart'; // Necesario para seleccionar imágenes

class ProfileScreen extends StatefulWidget {
  // 1. Recibimos la imagen y la biografía inicial del HomeScreen
  final File? initialImage;
  final String initialBio;

  const ProfileScreen({
    super.key,
    this.initialImage,
    required this.initialBio, // Ahora es requerido
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- VARIABLES DE ESTADO ---
  bool _isEditing = false;
  late String _currentBio;
  final TextEditingController _bioController = TextEditingController();

  // Almacena la imagen de perfil (inicial o seleccionada)
  File? _imageFile;

  // URL de imagen de perfil por defecto (Usada si no hay imagen local)
  final String _defaultImageUrl =
      'https://images.unsplash.com/photo-1623038896180-d81dd785a60f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=870';

  @override
  void initState() {
    super.initState();
    // Inicializar estados con valores recibidos
    _imageFile =
        widget.initialImage; // Cargar la imagen que viene de HomeScreen
    _currentBio = widget.initialBio; // Cargar la bio que viene de HomeScreen
    _bioController.text = _currentBio;
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  // --- MÉTODOS ---

  void _toggleEdit() {
    // Si estamos en modo de edición y presionamos Guardar (Icons.save)
    if (_isEditing) {
      // MODO DE GUARDADO

      // 1. Guardamos los cambios de la biografía
      _currentBio = _bioController.text;

      // 2. Devolvemos la imagen y la bio en un Map al HomeScreen
      // Esto cierra la pantalla y dispara el setState en HomeScreen.
      Navigator.pop(context, {'imageFile': _imageFile, 'bio': _currentBio});

      // El código setState() que actualiza _isEditing ya no es necesario aquí
      // porque la pantalla se cierra con Navigator.pop
    } else {
      // Si estamos en modo de visualización y presionamos Editar (Icons.edit)
      setState(() {
        _isEditing = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modo de Edición activado.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // --- WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    // Determinar la ImageProvider a usar
    ImageProvider backgroundImage;
    if (_imageFile != null) {
      backgroundImage = FileImage(_imageFile!);
    } else {
      backgroundImage = NetworkImage(_defaultImageUrl);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AVATAR CON BOTÓN DE CAMBIO DE IMAGEN
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.deepPurple,
                    backgroundImage:
                        backgroundImage, // Usa la imagen determinada
                    child: _imageFile == null && _defaultImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blueAccent,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Información del perfil (simulada)
              const Text(
                'Nombre de Usuario',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'usuario@ejemplo.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Biografía
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Biografía:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),

              // Campo de Biografía (Editable condicionalmente)
              Container(
                decoration: BoxDecoration(
                  color: _isEditing ? Colors.white : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isEditing ? Colors.blue : Colors.transparent,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: _isEditing
                    ? TextFormField(
                        controller: _bioController,
                        maxLines: 5,
                        minLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Escribe algo sobre ti...',
                          border: InputBorder.none,
                        ),
                      )
                    : Text(_currentBio, style: const TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 50),
              const Text(
                'Otras opciones de configuración del perfil...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
