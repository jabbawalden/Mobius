// /*
//  * Other angelscript files can be imported by specifying their
//  * full path name from the Script folder.
//  *
//  * Folders should be separated by dots, and you always need
//  * to type the full path, there are no relative imports.
//  */
// import Examples.Example_Actor;

// /* After importing a module, you can directly use all the types and functions
//    in it as if it was declared here to begin with. */
void Test(AExampleActorType ImportedActor)
{
	ImportedActor.NewOverridableMethod();
}